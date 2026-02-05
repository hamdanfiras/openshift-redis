{{/*
Common helpers
*/}}

{{- define "redis-oss-sentinel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "redis-oss-sentinel.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "redis-oss-sentinel.labels" -}}
app.kubernetes.io/name: {{ include "redis-oss-sentinel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "redis-oss-sentinel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redis-oss-sentinel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "redis-oss-sentinel.redis.labels" -}}
{{ include "redis-oss-sentinel.labels" . }}
app.kubernetes.io/component: redis
{{- end -}}

{{- define "redis-oss-sentinel.sentinel.labels" -}}
{{ include "redis-oss-sentinel.labels" . }}
app.kubernetes.io/component: sentinel
{{- end -}}

{{- define "redis-oss-sentinel.annotations" -}}
{{- with .Values.commonAnnotations }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{- define "redis-oss-sentinel.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "redis-oss-sentinel.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{- define "redis-oss-sentinel.redis.fullname" -}}
{{- printf "%s-redis" (include "redis-oss-sentinel.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "redis-oss-sentinel.redis.headless" -}}
{{- printf "%s-redis-headless" (include "redis-oss-sentinel.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "redis-oss-sentinel.sentinel.fullname" -}}
{{- printf "%s-sentinel" (include "redis-oss-sentinel.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "redis-oss-sentinel.secretName" -}}
{{- if .Values.redis.auth.existingSecret -}}
{{- .Values.redis.auth.existingSecret -}}
{{- else -}}
{{- printf "%s-auth" (include "redis-oss-sentinel.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "redis-oss-sentinel.redis.port" -}}
{{- default 6379 .Values.redis.service.port -}}
{{- end -}}

{{- define "redis-oss-sentinel.sentinel.port" -}}
{{- default 26379 .Values.sentinel.service.port -}}
{{- end -}}