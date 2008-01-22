Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 04:12:03 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0MCBvSv030333
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 04:12:00 -0800
Received: from smtp3.vol.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B22A2545855
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 04:12:16 -0800 (PST)
Received: from smtp3.vol.cz (smtp3.vol.cz [195.250.128.83]) by cuda.sgi.com with ESMTP id F9B0PkPrJbFCHROT for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 04:12:16 -0800 (PST)
Received: from webmail2.vol.cz (webmail2.vol.cz [195.250.155.227])
	by smtp3.vol.cz (Postfix) with ESMTP id E29445971E
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 13:11:43 +0100 (CET)
Received: from webmail2.vol.cz (localhost.vol.cz [127.0.0.1])
	by webmail2.vol.cz (8.13.8/8.13.8) with ESMTP id m0MCBhKg018818
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 13:11:43 +0100 (CET)
	(envelope-from vtech@volny.cz)
MIME-Version: 1.0
Subject: =?iso-8859-2?Q?XFS_on_LVM2=2C_1st_drive_lost?=
From: vtech@volny.cz
Date: Tue, 22 Jan 2008 13:11:43 +0100 (CET)
Message-ID: <1019eb6b77e0a78e430104592107169a@www2.mail.volny.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I have LVM2 logical volume built of 6 harddrives (total capacity 1.3TB).
There is a single XFS filesystem on top of it.
The 1st drive (ie. pv0) died, so I'm missing the XFS filesystem headers.
What are my chances to rescue the data from drives, which are OK? (Over
80% of data). What should I do/try?

Thank You, Vit Kavan

PS.: Yes, I know, it's a stupid design. I'll never do it again, I promise
:)
