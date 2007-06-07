Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 11:56:39 -0700 (PDT)
Received: from psmtp13.wxs.nl (psmtp13.wxs.nl [195.121.247.25])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l57IuaWt014628
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 11:56:37 -0700
Received: from mail.deserver.nl (ip565e92ac.direct-adsl.nl [86.94.146.172])
 by psmtp13.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0JJA003NG4M9XH@psmtp13.wxs.nl> for xfs@oss.sgi.com; Thu,
 07 Jun 2007 20:56:34 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])	by mail.deserver.nl (Postfix)
 with ESMTP id C160F236CE	for <xfs@oss.sgi.com>; Thu,
 07 Jun 2007 20:56:32 +0200 (CEST)
Received: from [192.168.0.14] (unknown [192.168.0.14])
	by mail.deserver.nl (Postfix) with ESMTP id 38E8C236C6	for <xfs@oss.sgi.com>;
 Thu, 07 Jun 2007 20:56:26 +0200 (CEST)
Date: Thu, 07 Jun 2007 20:56:25 +0200
From: Jaap Struyk <japie@deserver.nl>
Subject: Re: ways to restore data from crashed disk
In-reply-to: <46684A9B.90908@deserver.nl>
Message-id: <466854D9.3070903@deserver.nl>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <465EA882.3030403@deserver.nl> <465ECF9B.2000500@sandeen.net>
 <46684A9B.90908@deserver.nl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_db hdd4.img

xfs_db> sb 0
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 36710528
rblocks = 0
rextents = 0
uuid = 9b1a2a9c-9572-426f-b234-b6ba89bae713
logstart = 33554436
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 2294408
agcount = 16
rbmblocks = 0
logblocks = 17925
versionnum = 0x3084
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 22
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 76864
ifree = 20402
fdblocks = 8890535
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0
features2 = 0
-- 
Groetjes Japie
