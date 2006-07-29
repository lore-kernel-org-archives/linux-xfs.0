Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Jul 2006 14:26:12 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6TLPqDW002889
	for <linux-xfs@oss.sgi.com>; Sat, 29 Jul 2006 14:25:57 -0700
Subject: Re: [PATCH] kill leftover WANT_FUNCS macro indirection
References: <44CAE247.6020608@sandeen.net>
From: Andi Kleen <ak@suse.de>
Date: 29 Jul 2006 22:08:21 +0200
In-Reply-To: <44CAE247.6020608@sandeen.net>
Message-ID: <p73k65w41je.fsf@verdi.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

Eric Sandeen <sandeen@sandeen.net> writes:

> This gets rid of some pointless macro defines... I had a version that
> lower-cased it all too but Nathan liked this better, and he's the man!
> :)

Shouted function names is not exactly Linux code style at least.

-Andi
