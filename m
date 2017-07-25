Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:54698 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbdGYKnK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 06:43:10 -0400
Subject: Re: request for inclusion of 04197b341f23 ("xfs: don't BUG() on mixed
 direct and mapped I/O")
References: <5bcfc94b-ecb9-468b-78f3-ae5de53f62a0@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <666c5faf-cbee-f83b-90bf-279284f0600b@applied-asynchrony.com>
Date: Tue, 25 Jul 2017 12:43:08 +0200
MIME-Version: 1.0
In-Reply-To: <5bcfc94b-ecb9-468b-78f3-ae5de53f62a0@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On 07/25/17 08:47, Nikolay Borisov wrote:
> I'd like to request the aforementioned patch to be included into stable
> kernels. I've attached the 4.4 backport, the patch got introduced in
> 4.10 so for 4.9 it will likely be able to apply cleanly, for 4.4 it
> needed a bit of adjustment.

It has been in 4.9-stable since January, see:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/fs/xfs?h=linux-4.9.y&id=3978c5bb004312fd267aed7279fe64b119e126b0

-h
