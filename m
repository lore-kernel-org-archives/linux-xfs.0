Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 23:34:56 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5P6Yrdo003420
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 23:34:54 -0700
Date: Mon, 25 Jun 2007 07:20:47 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] simplify vnode tracing calls
Message-ID: <20070625062047.GB1307@infradead.org>
References: <467F5053.4040108@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467F5053.4040108@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 25, 2007 at 12:19:15AM -0500, Eric Sandeen wrote:
> Don't think I've sent this one yet... :)

Any chance we can keep the name lower-cases despite the simplified
prototype?  Also it might make sense to merge the previous patch into
this one.
