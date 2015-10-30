{\rtf1\ansi\ansicpg1252\cocoartf1348\cocoasubrtf170
{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red255\green255\blue255;}
\paperw11900\paperh16840\margl1440\margr1440\vieww15480\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural

\f0\fs24 \cf0 - icinga muss vollst\'e4ndig \'fcber puppet konfigurierbar sein\
- templates bauen\
- assign where f\'fcr host zuordnung nutzen (siehe basics)\
- call gegen foreman api um die hosts zu fangen\
\
\
\pard\pardeftab720

\f1\fs26 \cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 object HostGroup \'93Hadoop-Datanodes\'94 \{\
  display_name = \'93Hadoop Datanodes\'94\
\
  assign where match(\'93dn*\'94, host.name)\
\}\
\
\pard\pardeftab720
\cf0 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 template Notification \'93Hadoop-Datanodes\'94 \{\
  display_name = \'93Hadoop Datanodes\'94\
\
  assign where match(\'93dn*\'94, host.name)\
\}}