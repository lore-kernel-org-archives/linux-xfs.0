Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752031AbdFPLGv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 07:06:51 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76B06C057FAD
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2017 11:06:50 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (unknown [10.40.205.55])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA23F94C5F
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2017 11:06:49 +0000 (UTC)
Date: Fri, 16 Jun 2017 13:06:47 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170616110647.b5dp5hvb7ylacdwr@eorzea.usersys.redhat.com>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170616105445.3314-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616105445.3314-3-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I forgot to add "V4" to the subject here, but the patch is still the V4 one

-- 
Carlos
