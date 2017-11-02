Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52404 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750753AbdKBGDQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 02:03:16 -0400
Date: Thu, 2 Nov 2017 07:03:15 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/18] xfs: use a b+tree for the in-core extent list
Message-ID: <20171102060315.GA20740@lst.de>
References: <20171031142230.11755-1-hch@lst.de> <20171031142230.11755-17-hch@lst.de> <20171101184725.GJ4911@magnolia> <20171102001627.GO4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102001627.GO4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Nov 01, 2017 at 05:16:27PM -0700, Darrick J. Wong wrote:
> FWIW the attached crap patch fixes all the fstests failures I saw.

Thanks, I'll take a look.  Been a little busy finishing off another
large non-xfs patchset and preparing a conference talk all at the same
time..
