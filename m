Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Aug 2006 07:33:44 -0700 (PDT)
Received: from web31704.mail.mud.yahoo.com (web31704.mail.mud.yahoo.com [68.142.201.184])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k73EXTDW025740
	for <xfs@oss.sgi.com>; Thu, 3 Aug 2006 07:33:30 -0700
Message-ID: <20060803143301.51757.qmail@web31704.mail.mud.yahoo.com>
Date: Thu, 3 Aug 2006 07:33:01 -0700 (PDT)
From: Heilige Gheist <hgheist@yahoo.com>
Subject: Concurrent mount of XFS over SAN
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Is there a way to prevent and/or detect concurrent mount of same XFS
SAN-based partition from several nodes?
I had to fsck a filesystem losing some data after two nodes happily
mounted a filesystem from same SAN-based partition at the same time and
wrote into it.
Thanks!

--alan

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
