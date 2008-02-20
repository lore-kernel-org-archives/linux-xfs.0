Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 19:59:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1K3wqAC007755
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2008 19:58:55 -0800
Date: Wed, 20 Feb 2008 14:59:05 +1100
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH, mainline-only] remove dmapi cruft in xfs_file.c
Message-ID: <20080220035905.GB69752007@melbourne.sgi.com>
References: <20080208044405.GB15013@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208044405.GB15013@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

* Christoph Hellwig <hch@lst.de> [2008-02-08 05:44:06 +0100]:

> The dmapi cruft in xfs_file.c is totally out of date in mainline vs
> CVS, and at this point just removing this code which can't be used on
> mainline at all seems to be the best option to keep it maintainable.

looks reasonable, I'll make sure it gets pushed to oss->mainline.
-- 
Niv
