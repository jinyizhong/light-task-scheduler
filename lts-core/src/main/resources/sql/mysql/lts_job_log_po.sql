CREATE TABLE IF NOT EXISTS `lts_job_log_po` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `gmt_created` bigint(20) COMMENT '日志创建时间',
  `log_time` bigint(20) COMMENT '日志记录时间',
  `log_type` varchar(32) COMMENT '日志类型',
  `success` tinyint(11) COMMENT '成功与否',
  `msg` text COMMENT '消息',
  `code` varchar(32) COMMENT '消息编码',
  `job_type` varchar(32) COMMENT '任务类型',
  `task_tracker_identity` varchar(64) COMMENT '执行节点唯一标识',
  `level` varchar(32) COMMENT '日志记录级别',
  `task_id` varchar(160) COMMENT '客户端ID',
  `real_task_id` varchar(160) COMMENT '客户端ID',
  `job_id` varchar(64) DEFAULT '' COMMENT '服务端生成ID',
  `priority` int(11) COMMENT '优先级',
  `submit_node_group` varchar(64) COMMENT '提交节点组',
  `task_tracker_node_group` varchar(64) COMMENT '执行节点组',
  `ext_params` text COMMENT '用户参数',
  `internal_ext_params` text COMMENT '内部扩展参数 JSON',
  `need_feedback` tinyint(4) COMMENT '是否需要反馈',
  `cron_expression` varchar(128) COMMENT 'cron表达式',
  `trigger_time` bigint(20) COMMENT '触发时间',
  `retry_times` int(11) COMMENT '重试次数',
  `max_retry_times` int(11) DEFAULT '0' COMMENT '最大重试次数',
  `rely_on_prev_cycle` tinyint(4) COMMENT '是否依赖上一个执行周期',
  `repeat_count` int(11) DEFAULT '0' COMMENT '重复一次',
  `repeated_count` int(11) DEFAULT '0' COMMENT '已经重复的次数',
  `repeat_interval` bigint(20) DEFAULT '0' COMMENT '重复间隔',
  `need_alarm` varchar(1) DEFAULT NULL COMMENT '是否需要报警 0否',
  PRIMARY KEY (`id`),
  KEY `log_time` (`log_time`),
  KEY `task_id_task_tracker_node_group` (`task_id`,`task_tracker_node_group`),
  KEY `idx_realTaskId_taskTrackerNodeGroup` (`real_task_id`, `task_tracker_node_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='任务日志';