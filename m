Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56397 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932571AbdKBTLI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 15:11:08 -0400
Date: Thu, 2 Nov 2017 20:11:07 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/18] xfs: introduce the xfs_iext_cursor abstraction
Message-ID: <20171102191107.GA4838@lst.de>
References: <20171031142230.11755-1-hch@lst.de> <20171031142230.11755-13-hch@lst.de> <20171031220234.GT4911@magnolia> <20171102184942.GB4244@lst.de> <20171102190115.GY4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102190115.GY4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 12:01:15PM -0700, Darrick J. Wong wrote:
> How many more patches do you have after the ones you've already sent?

None for now, but they are fairly iterative.

> I /do/ have the ability to do evil things like sed -e 's/ext,/icur,/g'
> to the patches and re-stuff them in the git branch.  I probably wouldn't
> bother with the ones already named 'cur', it's just the 'ext' ones that
> increase my cognitive impedance.

Ok, I'll look into it for V2.
