{{- define "togglemaster.name" -}}
togglemaster
{{- end -}}

{{- define "togglemaster.fullname" -}}
{{- $name := include "togglemaster.name" . -}}
{{- if .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "togglemaster.serviceAccountName" -}}
{{- if .Values.serviceAccount.name -}}
{{- .Values.serviceAccount.name -}}
{{- else if .Values.serviceAccount.create -}}
{{- printf "%s-%s" .Release.Name "sa" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- "" -}}
{{- end -}}
{{- end -}}
