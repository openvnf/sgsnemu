{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sgsnemu.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "sgsnemu.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sgsnemu.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "to.erlang.ip" -}}
{ {{- splitList "." . | join "," -}} }
{{- end -}}

{{- define "gtp-proxy.sockets.gtp-u" -}}
[
  {{- range $i, $a := initial . }}
 {'grx-{{- $i -}}', [{ip, {{ splitList "/" $a.ipAddr| first | include "to.erlang.ip" -}} },
            {netdev, "{{ $a.interface }}"},
            freebind
           ]},
  {{- end -}}{{- $a := last . }}
 {'grx-{{- initial . | len -}}', [{ip, {{ splitList "/" $a.ipAddr| first | include "to.erlang.ip" -}} },
            {netdev, "{{ $a.interface }}"},
            freebind
           ]}
]
{{- end -}}


{{- define "gtp-proxy.sockets.gtp-c" -}}
[
  {{- range $i, $a := initial . }}
 {'irx-{{- $i -}}', [{type, 'gtp-c'},
            {ip, {{ splitList "/" $a.ipAddr| first | include "to.erlang.ip" -}} },
            {netdev, "{{ $a.interface }}"},
            freebind
           ]},
 {'grx-{{- $i -}}', [{type, 'gtp-u'},
            {node, 'ergw-gtp-u-edp@gtp-proxy'},
            {name, 'grx-{{- $i -}}'}
           ]},
  {{- end -}}{{- $a := last . -}}{{- $i := initial . | len }}
 {'irx-{{- $i -}}', [{type, 'gtp-c'},
            {ip, {{ splitList "/" $a.ipAddr| first | include "to.erlang.ip" -}} },
            {netdev, "{{ $a.interface }}"},
            freebind
           ]},
 {'grx-{{- $i -}}', [{type, 'gtp-u'},
            {node, 'ergw-gtp-u-edp@gtp-proxy'},
            {name, 'grx-{{- $i -}}'}
           ]}
]
{{- end -}}


{{- define "gtp-proxy.socketlist.gtp-c" -}}
[{{- range $i, $a := initial . -}}'irx-{{ $i }}', {{ end -}}
  'irx-{{ initial . | len }}']
{{- end -}}

{{- define "gtp-proxy.socketlist.gtp-u" -}}
[{{- range $i, $a := initial . -}}'grx-{{ $i }}', {{ end -}}
  'grx-{{ initial . | len }}']
{{- end -}}
