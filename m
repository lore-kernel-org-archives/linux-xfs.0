Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:57252 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbeLGNJU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Dec 2018 08:09:20 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id wB7D9HfP015023
        for <linux-xfs@vger.kernel.org>; Fri, 7 Dec 2018 05:09:19 -0800
Message-ID: <5C0A70FD.6080806@tlinx.org>
Date: Fri, 07 Dec 2018 05:09:17 -0800
From: L A Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: RFD: question/probe regarding adding dump-levels A-Z after 0-9 for
 xfs{dump,restore}
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

How difficult would it be to allow 26 more dump levels
in xfs dump/restore?  Theoretically anyone using 0-9
would see no change.  Would there be some "problem" or
"gotcha" in adding in what would _seem_ to be a simple
change?

thanks,
-linda
