-- metrics --

ALTER TABLE ACT_RU_METER_LOG 
  ADD REPORTER_ varchar(255);

-- job prioritization --
  
ALTER TABLE ACT_RU_JOB
  ADD PRIORITY_ bigint NOT NULL
  DEFAULT 0;

ALTER TABLE ACT_RU_JOBDEF
  ADD JOB_PRIORITY_ bigint;

ALTER TABLE ACT_HI_JOB_LOG
  ADD JOB_PRIORITY_ bigint NOT NULL
  DEFAULT 0;

-- create decision definition table --
create table ACT_RE_DECISION_DEF (
    ID_ varchar(64) NOT NULL,
    REV_ integer,
    CATEGORY_ varchar(255),
    NAME_ varchar(255),
    KEY_ varchar(255) NOT NULL,
    VERSION_ integer NOT NULL,
    DEPLOYMENT_ID_ varchar(64),
    RESOURCE_NAME_ varchar(4000),
    DGRM_RESOURCE_NAME_ varchar(4000),
    primary key (ID_)
);

-- create unique constraint on ACT_RE_DECISION_DEF --
alter table ACT_RE_DECISION_DEF
    add constraint ACT_UNIQ_DECISION_DEF
    unique (KEY_,VERSION_);

-- case execution repetition rule --

ALTER TABLE ACT_RU_CASE_EXECUTION
  ADD REPEATABLE_ bit;

ALTER TABLE ACT_RU_CASE_EXECUTION
  ADD REPETITION_ bit;

-- historic case activity instance repetition rule --

ALTER TABLE ACT_HI_CASEACTINST
  ADD REPEATABLE_ bit;

ALTER TABLE ACT_HI_CASEACTINST
  ADD REPETITION_ bit;

-- case sentry part source --

ALTER TABLE ACT_RU_CASE_SENTRY_PART
  ADD SOURCE_ varchar(255);
  
-- create history decision instance table --
create table ACT_HI_DECINST (
    ID_ varchar(64) NOT NULL,
    DEC_DEF_ID_ varchar(64) NOT NULL,
    DEC_DEF_KEY_ varchar(255) NOT NULL,
    DEC_DEF_NAME_ varchar(255),
    PROC_DEF_KEY_ varchar(255),             
    PROC_DEF_ID_ varchar(64),               
    PROC_INST_ID_ varchar(64),
    ACT_INST_ID_ varchar(64),
    ACT_ID_ varchar(255),
    EVAL_TIME_ timestamp not null,
    COLLECT_VALUE_ double,
    primary key (ID_)
);

-- create history decision input table --
create table ACT_HI_DEC_IN (
    ID_ varchar(64) NOT NULL,
    DEC_INST_ID_ varchar(64) NOT NULL,      
    CLAUSE_ID_ varchar(64) NOT NULL,
    CLAUSE_NAME_ varchar(255),
    VAR_TYPE_ varchar(100),               
    BYTEARRAY_ID_ varchar(64),
    DOUBLE_ double,
    LONG_ bigint,
    TEXT_ varchar(4000),
    TEXT2_ varchar(4000),    
    primary key (ID_)
);

-- create history decision output table --
create table ACT_HI_DEC_OUT (
    ID_ varchar(64) NOT NULL,
    DEC_INST_ID_ varchar(64) NOT NULL,         
    CLAUSE_ID_ varchar(64) NOT NULL,
    CLAUSE_NAME_ varchar(255),
    RULE_ID_ varchar(64) NOT NULL,
    RULE_ORDER_ integer,
    VAR_NAME_ varchar(255),
    VAR_TYPE_ varchar(100),               
    BYTEARRAY_ID_ varchar(64),
    DOUBLE_ double,
    LONG_ bigint,
    TEXT_ varchar(4000),
    TEXT2_ varchar(4000),
    primary key (ID_)
);

-- create indexes for historic decision tables
create index ACT_IDX_HI_DEC_INST_ID on ACT_HI_DECINST(DEC_DEF_ID_);
create index ACT_IDX_HI_DEC_INST_KEY on ACT_HI_DECINST(DEC_DEF_KEY_);
create index ACT_IDX_HI_DEC_INST_PI on ACT_HI_DECINST(PROC_INST_ID_);
create index ACT_IDX_HI_DEC_INST_ACT on ACT_HI_DECINST(ACT_ID_);
create index ACT_IDX_HI_DEC_INST_ACT_INST on ACT_HI_DECINST(ACT_INST_ID_);
create index ACT_IDX_HI_DEC_INST_TIME on ACT_HI_DECINST(EVAL_TIME_);

create index ACT_IDX_HI_DEC_IN_INST on ACT_HI_DEC_IN(DEC_INST_ID_);
create index ACT_IDX_HI_DEC_IN_CLAUSE on ACT_HI_DEC_IN(DEC_INST_ID_, CLAUSE_ID_);

create index ACT_IDX_HI_DEC_OUT_INST on ACT_HI_DEC_OUT(DEC_INST_ID_);
create index ACT_IDX_HI_DEC_OUT_RULE on ACT_HI_DEC_OUT(RULE_ORDER_, CLAUSE_ID_);
