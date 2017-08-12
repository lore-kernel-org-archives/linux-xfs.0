Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdHLHiE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Aug 2017 03:38:04 -0400
Date: Sat, 12 Aug 2017 00:37:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170812073758.GA29036@infradead.org>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <20170809213307.GJ21024@dastard>
 <20170811125310.GA31001@infradead.org>
 <20170811165241.GE24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811165241.GE24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, alex@zadarastorage.com, linux-xfs@vger.kernel.org, bfoster@redhat.com, libor.klepac@bcom.cz

On Fri, Aug 11, 2017 at 09:52:41AM -0700, Darrick J. Wong wrote:
> Could you send them to the list, please? :)

I'll try to dig it out - it's on top of another larger series,
and I'm a little overloaded with work at the moment.
