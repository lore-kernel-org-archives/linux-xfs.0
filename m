Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 19:12:46 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBH3CfiA014034
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 19:12:42 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A2E048D5AD
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 19:12:52 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id itdeLyfGkYEHuIUi for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 19:12:52 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 7B545182DD2DB
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 21:12:50 -0600 (CST)
Message-ID: <4765E932.7060605@sandeen.net>
Date: Sun, 16 Dec 2007 21:12:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Installing grub onto a system with XFS root fs
References: <20071217004945.GA13335@jdc.jasonjgw.net> <4765CBBF.1020207@sandeen.net> <20071217014627.GA13692@jdc.jasonjgw.net>
In-Reply-To: <20071217014627.GA13692@jdc.jasonjgw.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Jason White wrote:

> Manually unfreezing the file system with xfs_freeze -u /
> worked for me on one machine. (This was done while grub-install was executing,
> after it executed xfs_freeze).
> 
> 
sounds like a bug in the scripts, then.

-Eric
