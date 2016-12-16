Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49408 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754214AbcLPHxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Dec 2016 02:53:51 -0500
Date: Thu, 15 Dec 2016 23:53:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] duperemove: test presence of dedupe ioctl
Message-ID: <20161216075303.GA14470@infradead.org>
References: <20161209175645.GB16813@birch.djwong.org>
 <20161214104436.GB16862@infradead.org>
 <20161214183845.GA5357@birch.djwong.org>
 <20161214192607.GA2280@infradead.org>
 <20161216012014.GG5357@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161216012014.GG5357@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, mfasheh@versity.com, xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Thu, Dec 15, 2016 at 05:20:14PM -0800, Darrick J. Wong wrote:
> Fair enough, no need to pollute the namespace.

Or confuse poor readers with the 'fake' name :)
