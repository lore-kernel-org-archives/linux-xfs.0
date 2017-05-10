Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50303 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751955AbdEJOPs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 10:15:48 -0400
Date: Wed, 10 May 2017 16:15:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: use uuid_be to implement the uuid_t type
Message-ID: <20170510141546.GA23916@lst.de>
References: <20170505075725.19597-3-hch@lst.de> <CAOQ4uxg=wLW9d195W_Ro71iNZEt8jVFyVwXysd-WnuDx7ELKDw@mail.gmail.com> <20170505084813.GA4805@lst.de> <1493977343.30052.23.camel@linux.intel.com> <20170505095617.GA6762@lst.de> <1493978788.30052.29.camel@linux.intel.com> <20170505101052.GB7095@lst.de> <CAOQ4uxh_gAUDiCY6yHcTiXRTBzKZv7R7PquAXRzztxRE0yb0wQ@mail.gmail.com> <20170510120119.GA20271@lst.de> <1494420895.16411.4.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494420895.16411.4.camel@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 10, 2017 at 03:54:55PM +0300, Andy Shevchenko wrote:
> I'm fine with above and it looks like I could rebase my current work
> whenever (1) has been done.
> 
> Looking forward to repository with changes I can rebase on top of.

Here is what I currently have:

http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/uuid-types

It hasn't survived the buildbot yet, so take it with a grain of salt.
