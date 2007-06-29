Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Jun 2007 10:43:23 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5THhFtL018977
	for <xfs@oss.sgi.com>; Fri, 29 Jun 2007 10:43:17 -0700
Date: Fri, 29 Jun 2007 13:42:48 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/6][TAKE5] fallocate system call
Message-ID: <20070629174248.GD16268@thunk.org>
References: <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070628025543.9467216f.akpm@linux-foundation.org> <20070628175757.GA1674@amitarora.in.ibm.com> <20070628113342.c9c0f49c.akpm@linux-foundation.org> <20070629135612.GH29279@thunk.org> <46851741.3030707@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46851741.3030707@garzik.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Fri, Jun 29, 2007 at 10:29:21AM -0400, Jeff Garzik wrote:
> >In any case, the plan is to push all of the core bits into Linus tree
> >for 2.6.22 once it opens up, which should be Real Soon Now, it looks
> >like.
> 
> Presumably you mean 2.6.23.

Yes, sorry.  I meant once Linus releases 2.6.22, and we would be
aiming to merge before the 2.6.23-rc1 window.

						- Ted
