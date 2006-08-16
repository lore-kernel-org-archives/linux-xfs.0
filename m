Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 16:47:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7GNkbDW001877
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 16:46:50 -0700
Date: Thu, 17 Aug 2006 09:45:42 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: fsblock zero - don't panic
Message-ID: <20060817094542.D2787212@wobbly.melbourne.sgi.com>
References: <20060810155851.C2591606@wobbly.melbourne.sgi.com> <20060811032626.GF50254148@melbourne.sgi.com> <20060816142800.D2762042@wobbly.melbourne.sgi.com> <1155713014.7103.345.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1155713014.7103.345.camel@localhost.localdomain>; from stewart@flamingspork.com on Wed, Aug 16, 2006 at 03:23:33PM +0800
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stewart Smith <stewart@flamingspork.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Wed, Aug 16, 2006 at 03:23:33PM +0800, Stewart Smith wrote:
> On Wed, 2006-08-16 at 14:28 +1000, Nathan Scott wrote:
> > +		error = EFSCORRUPTED;
> 
> should this be XFS_ERROR(EFSCORRUPTED) ?

*nod*, will do, thanks.

cheers.

-- 
Nathan
