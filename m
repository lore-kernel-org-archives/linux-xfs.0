Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbdDLQUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 12:20:36 -0400
Date: Wed, 12 Apr 2017 09:20:36 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Deadlock between block allocation and block truncation
Message-ID: <20170412162036.GB8663@infradead.org>
References: <800468eb-3ded-9166-20a4-047de8018582@gmail.com>
 <20170412161017.GA16590@infradead.org>
 <7459d8b3-81fe-875c-1b14-b30089365d8d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7459d8b3-81fe-875c-1b14-b30089365d8d@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 07:12:50PM +0300, Nikolay Borisov wrote:
> I will apply this to 3.12 and 4.4 and run tests since I can reproduce
> fairly reliably on those. You don't expect any fallout on older kernel,
> yes ?

No.
