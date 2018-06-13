Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46064 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934978AbeFMTd2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 15:33:28 -0400
Received: from Liberator-5.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9D5632ACC
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jun 2018 14:33:03 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/2] mkfs: 2 more fixes
Message-ID: <7a30c780-d69a-71d4-d0e6-a5fcefda08e6@sandeen.net>
Date: Wed, 13 Jun 2018 14:33:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

A bugfix and a simplification/tidyup ...
