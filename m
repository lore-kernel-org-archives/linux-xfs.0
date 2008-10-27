Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 10:15:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RHFNbS018277
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 10:15:23 -0700
Message-ID: <4905F727.8030005@sandeen.net>
Date: Mon, 27 Oct 2008 12:15:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Is it possible the check an frozen XFS filesytem to avoid downtime
References: <200807141542.51613.ms@teamix.de> <200807150944.13277.ms@teamix.de> <487CC1EB.6030100@sandeen.net> <200810271757.09915.ms@teamix.de>
In-Reply-To: <200810271757.09915.ms@teamix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <ms@teamix.de>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

Martin Steigerwald wrote:

> A colleague did a kernel update on the inactive backend 1 server from 2.6.21 
> to 2.6.26 kernel from backports.org, tommorow backend 2 will follow. Let's 
> see whether that solves the issue.
> 
> Anyway it seems to be a hard to trigger bug and before bugging you with 
> something in kernel 2.6.21, we at least update to the latest backports.org 
> kernel.

Honestly, I'd try a 2.6.27 kernel if you can, a few more problems were
fixed there.

-Eric
