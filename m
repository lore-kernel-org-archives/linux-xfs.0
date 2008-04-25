Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 Apr 2008 02:55:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3P9t0fO024641
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 02:55:06 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C482AE9A1D
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 02:55:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id sDFS5vSMwTRaD9n7 for <xfs@oss.sgi.com>; Fri, 25 Apr 2008 02:55:41 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <480FA737.5030001@sandeen.net>
References: <480FA737.5030001@sandeen.net>
Subject: Re: [PATCH] convert xfs to use ERR_CAST
Date: Fri, 25 Apr 2008 10:55:39 +0100
Message-ID: <15702.1209117339@redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: dhowells@redhat.com, xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen <sandeen@sandeen.net> wrote:

> Looks like somehow xfs got missed in the conversion that
> took place in e231c2ee64eb1c5cd3c63c31da9dac7d888dcf7f,
> "Convert ERR_PTR(PTR_ERR(p)) instances to ERR_CAST(p) <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e231c2ee64eb1c5cd3c63c31da9dac7d888dcf7f>"
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Acked-by: David Howells <dhowells@redhat.com>
