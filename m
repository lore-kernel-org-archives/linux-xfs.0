Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54545 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753218AbdHKQ2C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 12:28:02 -0400
Date: Fri, 11 Aug 2017 09:27:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Message-ID: <20170811162759.GA15629@infradead.org>
References: <20170519002032.GA21202@birch.djwong.org>
 <1495202431.1896310.982081664.066926F8@webmail.messagingengine.com>
 <20170519190115.GJ4519@birch.djwong.org>
 <1501791890.2285873.1062452112.61520C55@webmail.messagingengine.com>
 <20170805141621.GA10457@infradead.org>
 <20170805154528.GI24087@magnolia>
 <20170811100230.GC7064@infradead.org>
 <20170811162620.GC24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811162620.GC24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Colin Walters <walters@verbum.org>, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Aug 11, 2017 at 09:26:20AM -0700, Darrick J. Wong wrote:
> "Ensure that <insert insufficient engineering insult here> external fs
> drivers can find files on disk." :P

If they are correctly implemented they can always access it anyway..
