Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44476 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbeJWMZG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Oct 2018 08:25:06 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 72924B6A
        for <linux-xfs@vger.kernel.org>; Mon, 22 Oct 2018 23:03:01 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/2] xfs_repair: two fixes
Message-ID: <9070c949-2720-75ea-01c3-74261bf62f87@sandeen.net>
Date: Mon, 22 Oct 2018 23:03:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Two fixes for bugs that came up in the past 2 days ...
