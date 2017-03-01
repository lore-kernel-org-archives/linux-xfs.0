Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51899 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752100AbdCAPH4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 10:07:56 -0500
Date: Wed, 1 Mar 2017 16:07:37 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] failure atomic writes for file systems and block devices
Message-ID: <20170301150737.GE12248@lst.de>
References: <20170228145737.19016-1-hch@lst.de> <CAOQ4uxjYwP+XGdDu-HiKmiAVEFydqYj6xfQbaKULB9WWUSuX5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjYwP+XGdDu-HiKmiAVEFydqYj6xfQbaKULB9WWUSuX5g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-api@vger.kernel.org, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>

On Wed, Mar 01, 2017 at 01:21:41PM +0200, Amir Goldstein wrote:
> [CC += linux-api@vger.kernel.org] for that question and for the new API

We'll need to iterate over the API a few more times first I think..
