Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56105 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbfAaHks (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 02:40:48 -0500
Date: Thu, 31 Jan 2019 08:40:47 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: move noatime and automount flags setting into common code
Message-ID: <20190131074047.GA26171@lst.de>
References: <20190121152326.9954-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121152326.9954-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, devel@lists.orangefs.org

On Mon, Jan 21, 2019 at 04:23:24PM +0100, Christoph Hellwig wrote:
> Hi Al,
> 
> can you take a look at this series that fixes incorrect attributes
> reported for filesystems like XFS that don't use generic_filattr?

Al,

can you pick this up?
