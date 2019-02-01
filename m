Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:47656 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBAG4l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 01:56:41 -0500
Date: Fri, 1 Feb 2019 06:56:36 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: move noatime and automount flags setting into common code
Message-ID: <20190201065636.GN2217@ZenIV.linux.org.uk>
References: <20190121152326.9954-1-hch@lst.de>
 <20190131074047.GA26171@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131074047.GA26171@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>, Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, devel@lists.orangefs.org

On Thu, Jan 31, 2019 at 08:40:47AM +0100, Christoph Hellwig wrote:
> On Mon, Jan 21, 2019 at 04:23:24PM +0100, Christoph Hellwig wrote:
> > Hi Al,
> > 
> > can you take a look at this series that fixes incorrect attributes
> > reported for filesystems like XFS that don't use generic_filattr?
> 
> Al,
> 
> can you pick this up?

Applied.
