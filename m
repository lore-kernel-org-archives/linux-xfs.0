Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbeJKN0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:26:20 -0400
Date: Wed, 10 Oct 2018 23:00:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/18] libxfs: silence sparse static function warnings in
 util.c
Message-ID: <20181011060038.GI20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-10-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-10-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:13PM -0500, Eric Sandeen wrote:
> libxfs.h exports functions defined in util.c, so include that file to
> silence sparse warnings about potential static functions.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
