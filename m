Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 15:46:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2OMkdKM024859
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 15:46:41 -0700
Date: Tue, 25 Mar 2008 09:47:03 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH]fix the algorithm for addname in xfs_da_node_lookup_int
Message-ID: <20080324224703.GE103491721@sgi.com>
References: <47E5AC7D.4080708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E5AC7D.4080708@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kevin Xu <cgxu.gg@gmail.com>
Cc: xfscn@googlegroups.com, xfs@oss.sgi.com

On Sun, Mar 23, 2008 at 09:03:57AM +0800, Kevin Xu wrote:
> fix the algorithm for addname in xfs_da_node_lookup_int

As Eric already asked, please include a complete description of the
problem you are fixing, as well as including a "Signed-off-by"
line as per Documentation/SubmittingPatches.

What you've indicated may indeed be a bug, but I'd like to see a
test case that demonstrates the problem first and that your patch
fixes the test case.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
