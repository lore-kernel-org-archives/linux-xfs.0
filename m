Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31259 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbfBSXMe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Feb 2019 18:12:34 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C04A5811C0
        for <linux-xfs@vger.kernel.org>; Tue, 19 Feb 2019 23:12:34 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92D331001E82
        for <linux-xfs@vger.kernel.org>; Tue, 19 Feb 2019 23:12:34 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/3] xfsprogs: minor 4.20 fixups
Message-ID: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
Date: Tue, 19 Feb 2019 17:12:33 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Address a few nitpicks picked up by code scanners, 2 of which
are "new" in 4.20.
