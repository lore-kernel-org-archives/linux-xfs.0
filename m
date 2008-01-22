Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 15:01:35 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0MN1VAI014375
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 15:01:32 -0800
Received: from mail47.messagelabs.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 51EAD54B272
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 15:01:50 -0800 (PST)
Received: from mail47.messagelabs.com (mail47.messagelabs.com [216.82.240.163]) by cuda.sgi.com with SMTP id 1XNYhCpIdA0Ciw5Z for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 15:01:50 -0800 (PST)
Subject: xfs_rapair memory requirement per TB
From: Rene Salmon <salmr0@bp.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Jan 2008 17:01:22 -0600
Message-Id: <1201042882.32649.256.camel@holwrs01.bp.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

Reading the "Repairing a possibly incomplete xfs_growfs command?" thread
this month makes me wonder if there is some type of rough formula or
guesstimation cheat sheet to figure out how much memory and swap one
would need for an xfs_repair given a file system with many terabytes.


Say I have an 8TB LUN that needs an xfs_repair.  What would be the rough
memory requirements and swap space? 

Thanks
Rene
