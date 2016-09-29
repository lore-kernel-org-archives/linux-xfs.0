Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752479AbcI2NEo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Sep 2016 09:04:44 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4CF69C0921B0
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2016 13:04:44 +0000 (UTC)
Received: from redhat.com (vpn-54-24.rdu2.redhat.com [10.10.54.24])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u8TD4eF4019707
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2016 09:04:43 -0400
Date: Thu, 29 Sep 2016 15:04:40 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] [RFC] Release buffer locks in case of IO error
Message-ID: <20160929130440.xwxfq45bffm7ltlh@redhat.com>
References: <1475154050-28771-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475154050-28771-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Sorry, git send-email returned me an error while sending this, but looks like it
actually worked, so, Sorry for the several posts of the same patch ='(



-- 
Carlos
