Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Dec 2006 04:40:14 -0800 (PST)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBOCe8qw029652
	for <linux-xfs@oss.sgi.com>; Sun, 24 Dec 2006 04:40:09 -0800
Date: Sun, 24 Dec 2006 13:16:22 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: unexpected XFS SB magic number
Message-ID: <20061224121622.GA22721@teal.hq.k1024.org>
References: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu> <458C6719.6080106@sandeen.net> <Pine.SOL.4.58.0612221824500.2856@titan.cfa.harvard.edu> <458C6C5A.6090504@sandeen.net> <Pine.SOL.4.58.0612231748450.3446@titan.cfa.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOL.4.58.0612231748450.3446@titan.cfa.harvard.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Gaspar Bakos <gbakos@cfa.harvard.edu>
Cc: linux-xfs@oss.sgi.com

On Sat, Dec 23, 2006 at 06:08:58PM -0500, Gaspar Bakos wrote:
> So the questions are:
> - what partition type to choose next time?

In cases where I want to use the whole disk, I usually make the
filesystem directly over the disk (e.g. /dev/sdc) instead of
partitioning it.

Never had any problem with this setup.

Regards,
Iustin
