Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 21:13:46 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L5DT3G014757
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 21:13:34 -0800
Date: Mon, 21 Jan 2008 16:13:41 +1100
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: small problem w/ new xfs defaults patch
Message-ID: <20080121051341.GA31708862@melbourne.sgi.com>
References: <4794159F.9070505@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4794159F.9070505@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

* Eric Sandeen <sandeen@sandeen.net> [2008-01-20 21:46:39 -0600]:

> Index: xfsprogs-2.9.4/growfs/xfs_growfs.c
> ===================================================================
[...]
> couple things... you lost a "\n" off the end of the data section there...

That has been fixed, I guess it needs to be sent to oss  (barry?)

> Also, do you really want to drop reporting of unwritten extents?  Even
> if you're disallowing the selection on new mkfs's there may still be
> different flavors of filesystems in existence, should it still be reported?

I don't really care, whatever the oss/xfs-master people like best.

Cheers
-- 
Niv
