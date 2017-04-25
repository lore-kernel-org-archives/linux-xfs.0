Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41072 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1174717AbdDYBkD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Apr 2017 21:40:03 -0400
Date: Tue, 25 Apr 2017 03:40:01 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/2] mkfs: remove long long type casts
Message-ID: <20170425014001.GF28800@wotan.suse.de>
References: <20170419153025.10368-1-jtulak@redhat.com>
 <20170419153025.10368-2-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170419153025.10368-2-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2017 at 05:30:25PM +0200, Jan Tulak wrote:
> We have uint64, why cast it to long long for prints? Just print it as
> it is.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@kernel.org>

  Luis
