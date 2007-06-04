Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 08:12:32 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l54FCSWt032372
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 08:12:29 -0700
Date: Mon, 4 Jun 2007 16:12:28 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: apply transaction deltas atomically to superblock
Message-ID: <20070604151228.GD28425@infradead.org>
References: <20070604080720.GV85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604080720.GV85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Looks good and actually makes the code easier to read.
