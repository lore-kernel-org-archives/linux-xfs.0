Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFA6CCA473
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jun 2022 16:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbiFIQZB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jun 2022 12:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbiFIQZA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jun 2022 12:25:00 -0400
Received: from mitropoulos.debian.org (mitropoulos.debian.org [IPv6:2001:648:2ffc:deb:216:61ff:fe9d:958d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79AD1F2D0
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jun 2022 09:24:58 -0700 (PDT)
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:44962)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
        by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1nzKxs-0046IV-Jn
        for linux-xfs@vger.kernel.org; Thu, 09 Jun 2022 16:24:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wuOdmRvr0EHYhjrUxgKdhA9o8owkfjEJa0mePShFZWs=; b=SuiUiz4LkKdoy+jCdwa9b97/vW
        QtCFOgf2H2wUazMjZXNDHsfJzF3CCBbOE5aMazH9byQONo2p0mBMhqKZ8LttUCJ3ny+QpUtmC3Z6O
        F9v3dTw77QqCMBKhg14FYeAVVSrkzeEbBwUSD/qrfd9aw+Nh3zGBYd+h6HH2fV91SPS+yi7J9AOE0
        kd7B+J3U/hFXr3Vb/18XEhbK+nXoHM715he95fqFms0D4Kfolki/xN/ADe6/C/nzpcdm+/AhtrW1l
        Fr4sqj9TmtlN4P0bbTqRujedHSk5OuTlegTFqno50ackkyrWiiA0bH+1BjI2K5ztgYGnWKias4V0E
        IruYmiRw==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.92)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1nzKxq-0006zU-TP
        for linux-xfs@vger.kernel.org; Thu, 09 Jun 2022 16:24:54 +0000
To:     linux-xfs@vger.kernel.org
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_5.18.0-1_source.changes
Date:   Thu, 09 Jun 2022 16:24:54 +0000
X-Debian: DAK
X-DAK:  DAK
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1nzKxq-0006zU-TP@usper.debian.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs_5.18.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_5.18.0-1.dsc
  xfsprogs_5.18.0.orig.tar.xz
  xfsprogs_5.18.0-1.debian.tar.xz
  xfsprogs_5.18.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
