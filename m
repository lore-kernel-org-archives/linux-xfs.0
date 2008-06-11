Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 20:22:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5B3MTIq021756
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 20:22:29 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AE1CC72178
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 20:23:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id BXoZFVwiygw0UIVM for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 20:23:24 -0700 (PDT)
Message-ID: <484F452A.8090909@sandeen.net>
Date: Tue, 10 Jun 2008 22:23:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com>
In-Reply-To: <484F2CD7.9070506@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

Timothy Shimmin wrote:

> (1) It would be nice to know what the state of the apps really are.
> There is also the question of interaction with CXFS and NFS.
> Greg Banks has a compat matrix for NFS. It looks like the main
> things is to get something half recent - linux 2.6, nfs v3,
> apps which use 64 bit sys calls (eg. stat64) etc...
> Would need to do investigating.

Greg has a tool to scan binaries... some day I'm going to run it over
the fedora universe, I'll get back to you...  someday.

-Eric
