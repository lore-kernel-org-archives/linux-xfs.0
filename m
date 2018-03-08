Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58190 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933471AbeCHIQQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Mar 2018 03:16:16 -0500
Date: Thu, 8 Mar 2018 00:16:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] Get rid of XFS_BUF_SET_COUNT() macro
Message-ID: <20180308081615.GK15163@infradead.org>
References: <20180306130053.13958-1-cmaiolino@redhat.com>
 <20180306130053.13958-5-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180306130053.13958-5-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

Looks good, although it conflicts with Erics patches..
