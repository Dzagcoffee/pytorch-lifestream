for SC_EPOCHS in 015 010 005 020 025 030 040 050
do
  export SC_SUFFIX="epochs_${SC_EPOCHS}"
  python ../../pl_train_module.py \
      logger_name=${SC_SUFFIX} \
      params.rnn.hidden_size=1024 \
      trainer.max_epochs=${SC_EPOCHS} \
      model_path="models/mlm__$SC_SUFFIX.p" \
      --conf conf/mles_params.hocon
  python ../../pl_inference.py \
      model_path="models/mlm__$SC_SUFFIX.p" \
      output.path="data/emb_mles__$SC_SUFFIX" \
      --conf conf/mles_params.hocon
done

# Compare
rm results/scenario_alpha_battle__epochs.txt
# rm -r conf/embeddings_validation.work/
python -m embeddings_validation \
    --conf conf/embeddings_validation_short.hocon --workers 10 --total_cpu_count 20 \
    --conf_extra \
      'report_file: "../results/scenario_alpha_battle__epochs.txt",
      auto_features: ["../data/emb_mles__epochs_*.pickle"]'


export SC_SUFFIX="epochs_up_t0_30"
python ../../pl_train_module.py \
    logger_name=${SC_SUFFIX} \
    params.rnn.hidden_size=1024 \
    trainer.max_epochs=30 \
    params.train.checkpoints_every_n_val_epochs=1 \
    params.train.lr=0.001 \
    params.lr_scheduler.step_size=1 \
    params.lr_scheduler.step_gamma=0.8 \
    model_path="models/mlm__$SC_SUFFIX.p" \
    --conf conf/mles_params.hocon

CUDA_VISIBLE_DEVICES=3 python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=0-step\=4516.ckpt" \
    output.path="data/emb_mles__000" \
    inference_dataloader.loader.batch_size=512 \
    --conf conf/mles_params.hocon
CUDA_VISIBLE_DEVICES=3 python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=1-step\=9033.ckpt" \
    output.path="data/emb_mles__001" \
    inference_dataloader.loader.batch_size=512 \
    --conf conf/mles_params.hocon
CUDA_VISIBLE_DEVICES=3 python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=2-step\=13550.ckpt" \
    output.path="data/emb_mles__002" \
    inference_dataloader.loader.batch_size=512 \
    --conf conf/mles_params.hocon
CUDA_VISIBLE_DEVICES=3 python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=3-step\=18067.ckpt" \
    output.path="data/emb_mles__003" \
    inference_dataloader.loader.batch_size=512 \
    --conf conf/mles_params.hocon
CUDA_VISIBLE_DEVICES=3 python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=4-step\=22584.ckpt" \
    output.path="data/emb_mles__004" \
    inference_dataloader.loader.batch_size=512 \
    --conf conf/mles_params.hocon
python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=5-step\=27101.ckpt" \
    output.path="data/emb_mles__005" \
    --conf conf/mles_params.hocon
python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=6-step\=31618.ckpt" \
    output.path="data/emb_mles__006" \
    --conf conf/mles_params.hocon
python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=7-step\=36135.ckpt" \
    output.path="data/emb_mles__007" \
    --conf conf/mles_params.hocon
python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=8-step\=40652.ckpt" \
    output.path="data/emb_mles__008" \
    --conf conf/mles_params.hocon
python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=9-step\=45169.ckpt" \
    output.path="data/emb_mles__009" \
    --conf conf/mles_params.hocon
CUDA_VISIBLE_DEVICES=3 python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=10-step\=49686.ckpt" \
    output.path="data/emb_mles__010" \
    inference_dataloader.loader.batch_size=650 \
    --conf conf/mles_params.hocon
python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=11-step\=54203.ckpt" \
    output.path="data/emb_mles__011" \
    --conf conf/mles_params.hocon

python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=14-step\=67754.ckpt" \
    output.path="data/emb_mles__014" \
    --conf conf/mles_params.hocon
python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=17-step\=81305.ckpt" \
    output.path="data/emb_mles__017" \
    --conf conf/mles_params.hocon
python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=18-step\=85822.ckpt" \
    output.path="data/emb_mles__018" \
    --conf conf/mles_params.hocon
CUDA_VISIBLE_DEVICES=3 python ../../pl_inference.py \
    model_path="lightning_logs/epochs_up_t0_30/version_1/checkpoints/epoch\=19-step\=90339.ckpt" \
    output.path="data/emb_mles__019" \
    inference_dataloader.loader.batch_size=500 \
    --conf conf/mles_params.hocon

rm results/scenario_alpha_battle__epochs.txt
# rm -r conf/embeddings_validation.work/
python -m embeddings_validation \
    --conf conf/embeddings_validation_short.hocon --workers 10 --total_cpu_count 20 \
    --conf_extra \
      'report_file: "../results/scenario_alpha_battle__epochs.txt",
      auto_features: ["../data/emb_mles__???.pickle"]'
