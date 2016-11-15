Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966082AbcKOKTh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2016 05:19:37 -0500
Date: Tue, 15 Nov 2016 02:19:36 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/16] tools: create libxfs-diff to compare libxfses
Message-ID: <20161115101936.GK1607@infradead.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830454796.26713.8765931838477658280.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147830454796.26713.8765931838477658280.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Nov 04, 2016 at 05:09:07PM -0700, Darrick J. Wong wrote:
> Create a script to compare every file in libxfs to the same files
> in another libxfs.  This is useful for comparing upstream kernel
> and user progs to look for unported changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
