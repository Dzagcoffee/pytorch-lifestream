import logging
import math
import torch
from torch import nn

from dltranz.trx_encoder import PaddedBatch

logger = logging.getLogger(__name__)

try:
    from torch.nn import TransformerEncoder, TransformerEncoderLayer, LayerNorm
except ImportError:
    logger.error('Can not import Transformers')


class PositionalEncoding(nn.Module):
    def __init__(self, d_model, dropout=0.1, max_len=5000):
        super(PositionalEncoding, self).__init__()
        self.dropout = nn.Dropout(p=dropout)

        pe = torch.zeros(max_len, d_model)
        position = torch.arange(0, max_len, dtype=torch.float).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, d_model, 2).float() * (-math.log(10000.0) / d_model))
        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)
        pe = pe.unsqueeze(0).transpose(0, 1)
        self.register_buffer('pe', pe)

    def forward(self, x):
        x = x + self.pe[:x.size(0), :x.size(1)]
        return self.dropout(x)


class TransformerSeqEncoder(nn.Module):
    def __init__(self, input_size, params):
        super().__init__()
        enc_layer = TransformerEncoderLayer(
            d_model=input_size,
            nhead=params['n_heads'],
            dim_feedforward=params['dim_hidden'],
            dropout=params['dropout'])
        enc_norm = LayerNorm(input_size)
        self.enc = TransformerEncoder(enc_layer, params['n_layers'], enc_norm)
        self.pe = PositionalEncoding(max_len=params['max_seq_len'], d_model=input_size, dropout=params['dropout'])
        self.use_after_mask = params['use_after_mask']
        self.use_positional_encoding = params['use_positional_encoding']

    @staticmethod
    def generate_square_subsequent_mask(sz):
        r"""Generate a square mask for the sequence. The masked positions are filled with float('-inf').
            Unmasked positions are filled with float(0.0).
        """
        mask = (torch.triu(torch.ones(sz, sz)) == 1).transpose(0, 1)
        mask = mask.float().masked_fill(mask == 0, float('-inf')).masked_fill(mask == 1, float(0.0))
        return mask

    def forward(self, x):
        x_t = torch.transpose(x.payload, 0, 1)

        if self.use_after_mask:
            mask = self.generate_square_subsequent_mask(x_t.size(0)).to(x_t.device)
        else:
            mask = None

        if self.use_positional_encoding:
            x_t = self.pe(x_t)

        out = self.enc(x_t, mask)

        out = torch.transpose(out, 0, 1)

        return PaddedBatch(out, x.seq_lens)