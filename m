Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A308C43217
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 13:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239529AbiKQN0C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 08:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239864AbiKQNZ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 08:25:56 -0500
Received: from muffat.debian.org (muffat.debian.org [IPv6:2607:f8f0:614:1::1274:33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E5E70A1F
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 05:25:54 -0800 (PST)
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:42692)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
        by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1ovetu-00BtbI-Tu
        for linux-xfs@vger.kernel.org; Thu, 17 Nov 2022 13:25:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=0fHq4GLGXpzgzkk0uYPDYYRQ+l581Oo9igEtDs2pxfU=; b=JD49qwvtgYdgqbsNHLbRDAOiUn
        LTmWPku+oaAOeHC6yFYAlNzw1Y4et6o9uPeNGThaHE2LX49zpVMM70Cy371s6PTnDnkPzZkGh2x20
        PCbdb0HiOyap0CZZDJtRpQ/AaOgXbHBEB+5LtfHnLD3gi3iJoCKDyYoD9fNqtMQ5vpk0MUnQWCO31
        je1ziGKCaqI7I1TZosSHYi4VFJMlV83rniglo2bF/13SeW9BEEkFC2NqdXmVgjC2FYIS1IeWGp5MX
        w3C+W0zyUzBV21u5CtEIu1g8YVku+ynoVFdEi3BPBKIeX7suHDUU69qwqm/dAQu071MBp/G8LSpgp
        6uGbxwZg==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1ovets-00342O-8Z
        for linux-xfs@vger.kernel.org; Thu, 17 Nov 2022 13:25:52 +0000
To:     linux-xfs@vger.kernel.org
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.0.0-1_source.changes
Date:   Thu, 17 Nov 2022 13:25:51 +0000
X-Debian: DAK
X-DAK:  DAK
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1ovets-00342O-8Z@usper.debian.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs_6.0.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.0.0-1.dsc
  xfsprogs_6.0.0.orig.tar.xz
  xfsprogs_6.0.0-1.debian.tar.xz
  xfsprogs_6.0.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
