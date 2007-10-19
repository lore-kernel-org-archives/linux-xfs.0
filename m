Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 17:57:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9J0vQ8T031657
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 17:57:29 -0700
Date: Fri, 19 Oct 2007 10:57:22 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Make xfs_bulkstat() to report unlinked but referenced inodes
Message-ID: <20071019005722.GO995458@sgi.com>
References: <4715A22D.1070409@sgi.com> <4717FF91.5010902@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4717FF91.5010902@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs mailing list <xfs@oss.sgi.com>

On Fri, Oct 19, 2007 at 10:51:29AM +1000, Vlad Apostolov wrote:
> ping!
> 
> I ran XFS QA with this patch and didn't see any regressions and
> I (and Judith in US) have verified the expected behavior - xfs_bulkstat()
> now reports referenced inodes with link count of zero.

Looks fine, Vlad - all I was waiting for was the test results.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
