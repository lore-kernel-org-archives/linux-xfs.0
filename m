Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 02:44:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5A9iHxm030278
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 02:44:17 -0700
Received: from noire.bucharest.roedu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3602C67F73
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 02:45:12 -0700 (PDT)
Received: from noire.bucharest.roedu.net (noire.Bucharest.roedu.net [141.85.128.18]) by cuda.sgi.com with ESMTP id pWTraRRQU9Z3Xu8w for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 02:45:12 -0700 (PDT)
Received: from ahriman.bucharest.roedu.net (noire.bucharest.roedu.net [141.85.128.18])
	(authenticated bits=0)
	by noire.bucharest.roedu.net (8.12.10/8.12.10) with ESMTP id m5A8jFke009342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 11:45:15 +0300
From: dizzy <dizzy@roedu.net>
Subject: XFS directory entries sort order
Date: Tue, 10 Jun 2008 12:45:09 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101245.09950.dizzy@roedu.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello

Can someone tell me (in English or C :) ) the algorithm of the sorting order 
of the entries in an XFS directory as I would get them with a readdir() (or 
shell "find" command)?

I am trying to figure it out by reading linux/fs/xfs/xfs_dir2*.c code but I 
don't seem to be doing much progress and I was hoping maybe someone that 
knows these details can help.

Thank you!

-- 
Mihai RUSU					Email: dizzy@roedu.net
			"Linux is obsolete" -- AST
