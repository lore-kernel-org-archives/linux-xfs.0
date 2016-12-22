Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57351 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755957AbcLVI6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 03:58:07 -0500
Date: Thu, 22 Dec 2016 00:58:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] Fix building xfsprogs on 32-bit platforms
Message-ID: <20161222085804.GB23054@infradead.org>
References: <20161221190413.GA136777@gmail.com>
 <1a75e88c-014c-b245-2271-f7d201da1285@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a75e88c-014c-b245-2271-f7d201da1285@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Eric Biggers <ebiggers@google.com>, Felix Janda <felix.janda@posteo.de>

On Wed, Dec 21, 2016 at 03:33:11PM -0600, Eric Sandeen wrote:
> TBH I haven't really tested this on a 32-bit system yet,
> I'm sorry.  Right now, I plan to get it into the tree right
> after we cut the next release this week.

It would be useful to have it in the release to avoid a regression.
