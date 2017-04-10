Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59635 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbdDJQXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 12:23:16 -0400
Date: Mon, 10 Apr 2017 09:23:13 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: filesystem dead, xfs_repair won't help
Message-ID: <20170410162313.GA27122@infradead.org>
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <7ee4173a-93b4-4000-757f-52733a2edcca@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ee4173a-93b4-4000-757f-52733a2edcca@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Avi Kivity <avi@scylladb.com>, linux-xfs@vger.kernel.org

On Mon, Apr 10, 2017 at 10:49:55AM -0500, Eric Sandeen wrote:
> There is a known firmware bug on Intel 600P drives which
> causes corruption with XFS, FWIW.

Which apparently affects the whole range of controllers, e.g. also the
Pro 6000p and E6000p at least, no idea if there are any more.
