Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB9DC10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 18:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51C2D20684
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 18:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgCFSy4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 13:54:56 -0500
Received: from buxtehude.debian.org ([209.87.16.39]:43078 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgCFSy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 13:54:56 -0500
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1jAHsF-0004B6-Hn; Fri, 06 Mar 2020 18:39:03 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     linux-xfs@vger.kernel.org
Subject: Processed: xfsprogs: Build with libedit rather than libreadline5
Message-ID: <handler.s.C.158351982615085.transcript@bugs.debian.org>
References: <b4886a1c-128e-d15b-e8f9-b873d7713571@fishpost.de>
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Fri, 06 Mar 2020 18:39:03 +0000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> retitle 695875 Build with libedit rather than libreadline5
Bug #695875 [xfsprogs] xfsprogs: Build-Depend on libreadline6 rather than libreadline5
Changed Bug title to 'Build with libedit rather than libreadline5' from 'xfsprogs: Build-Depend on libreadline6 rather than libreadline5'.
> thanks
Stopping processing here.

Please contact me if you need assistance.
-- 
695875: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=695875
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
