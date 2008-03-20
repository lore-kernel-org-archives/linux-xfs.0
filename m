Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 00:45:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K7jCar006091
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 00:45:14 -0700
Date: Thu, 20 Mar 2008 03:45:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFSQA 103: filter ln output
Message-ID: <20080320074544.GC19969@infradead.org>
References: <20080320063245.GA103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320063245.GA103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 20, 2008 at 05:32:45PM +1100, David Chinner wrote:
> Move recent versions of ln (i.e. debian unstable) have
> a different error output. update the filter to handle this.

Looks good.
