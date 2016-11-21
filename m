Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39635 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754060AbcKURR5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Nov 2016 12:17:57 -0500
Date: Mon, 21 Nov 2016 18:17:55 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: new helpers to clean up extent tree lookups
Message-ID: <20161121171755.GA20310@lst.de>
References: <1479143565-30615-1-git-send-email-hch@lst.de> <b66cd943-7695-797d-cd80-d97019086e1b@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b66cd943-7695-797d-cd80-d97019086e1b@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Nov 18, 2016 at 06:21:32PM -0600, Eric Sandeen wrote:
> On 11/14/16 11:12 AM, Christoph Hellwig wrote:
> > Now that Eric send out xfs_iext_count before I could get to it I need
> > to get my other iext helpers out ASAP before running into another
> > rebase :)
> 
> I could have deferred if you had spoken up ;)
> 
> (I did think that iext_count probably wasn't the end of it)

Np - your patch was a good reminder that I should finally send this
series out.
