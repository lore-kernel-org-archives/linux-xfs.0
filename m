Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 13:22:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KKMmMS030193
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 13:22:48 -0700
Received: from qb-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAE045201AD
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 13:24:31 -0700 (PDT)
Received: from qb-out-1314.google.com (qb-out-1314.google.com [72.14.204.172]) by cuda.sgi.com with ESMTP id AHrrGZGvDEMdrfUs for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 13:24:31 -0700 (PDT)
Received: by qb-out-1314.google.com with SMTP id e19so2126851qba.8
        for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 13:24:31 -0700 (PDT)
Message-ID: <f40b17020810201324v48873a2ah51023120b17511d6@mail.gmail.com>
Date: Mon, 20 Oct 2008 22:24:29 +0200
From: Procurves <procurves@gmail.com>
Subject: Oops when mounting
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I get this oops when mounting my xfs partition, this specific one is for
2.6.24.5 (Slackware 12.1 Install Disc):
http://pastebin.com/f5f7f56a

I also run it through ksymoops:
http://pastebin.com/f42942ef9


The versions of the xfs-tools:
xfsdump_2.2.48-1
xfsprogs_2.9.7-1


This seems to happen with both linux kernels 2.6.22.19 and 2.6.26.6 as well,
I am however unable to retrive the oops from these. Also note that the
xfs-tools used with these kernels probably are older than the ones above.

The partition has now been reformatted as I have no spare time for this.
I hope this in some way will help you guys with your development of xfs.


Regards,

p
